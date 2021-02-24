%{

/* bulk_extractor include statements */
#include "../config.h"
#include "be13_api/bulk_extractor_i.h"

/* C include statements */
#include <cstring>
#include <cstdlib>
#include <stdio.h>

/* Include the flex scanner */
#include "sbuf_flex_scanner.h"

#define FEATURE_NAME "domains"

class domains_scanner : public sbuf_scanner {
public:
    char** domain_array;
    size_t domain_array_size;
        
    domains_scanner(const scanner_params &sp):
        sbuf_scanner(&sp.sbuf),
        domains_recorder(sp.fs.get_name("domains")),
        alert_recorder(sp.fs.get_alert_recorder()){
            // count the number of lines in the file called filename
            FILE *stream = fopen("domains_list.csv","r");
            char *saveptr = NULL;
            
            if (stream == NULL) {
                printf("\nDatei %s nicht gefunden!\n", "domains_list.csv");
                exit(EXIT_FAILURE);
            }
                
            int ch=0;
            int lines=0;
            while(!feof(stream))
            {
              ch = fgetc(stream);
              if(ch == '\n')
              {
                lines++;
              }
            }
            
            domain_array = (char **) malloc(lines * sizeof (char*));
            domain_array_size = lines;            
            
            rewind(stream);

            char *line = NULL;
            size_t len = 0;
            lines=0;

            if (stream == NULL)
                exit(EXIT_FAILURE);

            while ((getline(&line, &len, stream)) != -1) {
                
                char* tok;
                tok = strtok_r(line, ";", &saveptr);
                tok = strtok_r(NULL, "\n", &saveptr);
                
                if (tok != NULL) {
                    domain_array[lines]  = (char *) malloc(strlen(tok));
                    strcpy(domain_array[lines++] , tok);
                } else {
                    exit(EXIT_FAILURE);
                }
            }
            
            free(line);
            fclose(stream);
            
            qsort(domain_array, domain_array_size, sizeof(char *), compareStrings);
            
        }
        
        
        static void reverse_string(char *str)
        {
            /* skip null */
            if (str == 0)
            {
                return;
            }

            /* skip empty string */
            if (*str == 0)
            {
                return;
            }

            /* get range */
            char *start = str;
            char *end = start + strlen(str) - 1; /* -1 for \0 */
            char temp;

            /* reverse */
            while (end > start)
            {
                /* swap */
                temp = *start;
                *start = *end;
                *end = temp;

                /* move */
                ++start;
                --end;
            }
        }

        static int compareStrings(const void *pStr1, const void *pStr2) {
            char *str1 = (char *) malloc(strlen(*(char **)pStr1));
            strcpy(str1, *(char **)pStr1);
            reverse_string(str1);
            
            char *str2 = (char *) malloc(strlen(*(char **)pStr2));
            strcpy(str2, *(char **)pStr2);
            reverse_string(str2);
            int cmp_return = strcmp(str1, str2);
            delete []str1;
            delete []str2;
            return cmp_return;
        }
        
        ~domains_scanner() {
            delete []domain_array;
        }
        
        class feature_recorder *domains_recorder;
        class feature_recorder *alert_recorder;

};

#define YY_EXTRA_TYPE domains_scanner * /* holds our class pointer */
 
inline class domains_scanner *get_extra(yyscan_t yyscanner) {
    /* Placing decl here avoids redundent declaration warning  */ 
    YY_EXTRA_TYPE yydomains_get_extra (yyscan_t yyscanner ); 
    return yydomains_get_extra(yyscanner);
}


int my_strcmp(char *strg1, char *strg2)
{
    char *tmpstrg1 = strg1 + strlen(strg1);
    char *tmpstrg2 = strg2 + strlen(strg2);
    strg1 = strg1;
    strg2 = strg2;
    
    while( ( strg2 != tmpstrg2 ) && *tmpstrg1 == *tmpstrg2 )
    {
        tmpstrg1--;
        tmpstrg2--;
    }

    if(strg1 == tmpstrg1 && strg2 == tmpstrg2 && *tmpstrg1 == *tmpstrg2)
    {
        return 0; // strings are identical
     }
    else if (strg2 == tmpstrg2 && *tmpstrg1 == *tmpstrg2 && tmpstrg1 > strg1 && *(--tmpstrg1) == '.') {
        return 0; // right substing
    }    
    else
    {
        return 1;
    }
}

int in_array(char *array[], size_t size, char *lookfor)
{
    for (int i = 0; i < size; i++) {
        if (lookfor[strlen(lookfor) - 1] < array[i][strlen(array[i]) - 1]) {
            break;
        }
        
        if (strlen(lookfor) >= strlen(array[i]) && lookfor[strlen(lookfor) - strlen(array[i])] == array[i][0]) {
            if (my_strcmp(lookfor, array[i]) == 0) {
                return 1;
            }
            
        }
        
    }
    return 0;
}

bool validate_domain(char *text, char** domains_array, size_t domain_array_size)
{
    if (in_array(domains_array, domain_array_size, text))
        return 1;
    else
        return 0;
}


#define SCANNER "scan_domains"

%}

%option reentrant
%option noyywrap
%option 8bit
%option batch
%option case-insensitive
%option pointer
%option noyymore
%option prefix="yydomains_"

ALNUM        [a-zA-Z0-9]

%%


({ALNUM}{1,63}(-{ALNUM}{1,61})*\.)+[a-z]{2,24}    {
    //~ longest TLD (24): wget -qO - http://data.iana.org/TLD/tlds-alpha-by-domain.txt | tail -n+2 | wc -L
    domains_scanner &s = *yydomains_get_extra(yyscanner);
    if(validate_domain(yytext, s.domain_array, s.domain_array_size)){
        s.domains_recorder->write_buf(SBUF,s.pos,yyleng);
    }
    s.pos += yyleng; 
}

.|\n { 
    /**
    * The no-match rule.
    * If we are beyond the end of the margin, call it quits.
    */
    domains_scanner &s = *yydomains_get_extra(yyscanner);
    /* putchar(yytext[0]); */ /* Uncomment for debugging */
    s.pos++; 
}

%%

extern "C"
void scan_domains(const class scanner_params &sp,const recursion_control_block &rcb) {
    assert(sp.sp_version==scanner_params::CURRENT_SP_VERSION);
    if ( sp.phase==scanner_params::PHASE_STARTUP ) {
        assert(sp.info->si_version==scanner_info::CURRENT_SI_VERSION);
        sp.info->name           = "domains";
        sp.info->author         = "Christian C., https://github.com/cc-code-public";
        sp.info->description    = "Scans for domains";
        sp.info->scanner_version= "0.3";
        
        /* Define the feature files this scanner created */
        sp.info->feature_names.insert(FEATURE_NAME);

        /* Define the histograms to make */
        //sp.info->histogram_defs.insert(histogram_def("url","","histogram"));


        /*scan_domains_valid_debugg = sp.info->config->debug;*/  // get debug value
        return;
    }
    if ( sp.phase==scanner_params::PHASE_SCAN ) {
        domains_scanner lexer(sp);
        yyscan_t scanner;
        yydomains_lex_init(&scanner);
        yydomains_set_extra(&lexer,scanner);
        
        
        try {
            yydomains_lex(scanner);
        }
        catch (sbuf_scanner::sbuf_scanner_exception *e ) {
            std::cerr << "Scanner " << SCANNER << "Exception " << e->what() << " processing " << sp.sbuf.pos0 << "\n";
            delete e;
        }
                
        yydomains_lex_destroy(scanner);
    }
    if ( sp.phase==scanner_params::PHASE_NONE ) {
        // avoids defined but not used
        (void)yyunput;
        (void)yy_fatal_error;
    }
}
